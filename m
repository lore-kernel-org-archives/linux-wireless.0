Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:40003 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3K0NYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 08:24:46 -0500
Message-ID: <5295EB1D.1050604@meshcoding.com> (sfid-20131127_142449_040127_BDE9881B)
Date: Wed, 27 Nov 2013 13:52:45 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k pending patches
References: <1385547828-4330-1-git-send-email-sujith@msujith.org> <21141.51790.303263.385517@gargle.gargle.HOWL>
In-Reply-To: <21141.51790.303263.385517@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi Sujith,

On 27/11/13 11:32, Sujith Manoharan wrote:
>> * In both chips, "mac_postamble" needs an update - the
>> "ALWAYS_PERFORM_KEY_SEARCH" bit has to enabled. This is required
>> to address key cache corruption, which needs a bigger change in
>> the driver.


What patch is addressing this change? And can could please explain a
bit more about what is needed to address the key cache corruption problem?

Right now I am working on a "reactive behavior" which tries to detect
a cache corruption event and subsequently re-install all the keys one
by one to ensure they are back to a proper state.

What does this ALWAYS_PERFORM_KEY_SEARCH bit do? Is it set within the
initvalues?

Sorry for shooting all these questions at once, but I am really trying
to understand how to properly address this issue.


Cheers,


- -- 
Antonio Quartulli
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSlesdAAoJEADl0hg6qKeOwmYQALqHy2dYH77rgEUU6aXw9ulA
CKug0IeFESSoThkBeBtjKyH3xaLmH/d9AiInQWhawpSUblWu3d5+p37f1pdcuS/t
6M8rPbbW+1E/ig/tiYCWneyqJA7p/F5IQ/h0v/ScLwQaE+h2Dszdt+erIF8MgM19
TQuIJOR9HoMnw3d2I7Z6gCXxDY7lmuKjOH+5RJUq8xpJellgbRjvYk7hy0Y5TGYr
F0t3v3iA41VyFozVIGIXPM4O0+LAnK9iz6kEJ/PDdSOFxqxRPnhFtTPkyBKYCj6I
druE5L9NbzofKjEQEbU15Pr/8uHfCXo+INUbWVdvFtpjjRRGsrDzCnYTtIWd2XOL
AaV0hYIoSbs8Pbp03iOM4BKFj+dJXw6bfKWQZ5aB6jiEJqI7YCEzQKUgShz+bHR3
HYv9mP9y6BSku/kJUk3SZGx/3NtzqsYYwkMHaf8Z7Z9HVwLbc6WYVMcvgVuxs4Ke
L1gsnWadrctkyFQXeneVXbWyGVAsG/KbcMaR90mrac27Dw11JtdG+BdUjz56G7H4
WByXuCmzd4X57Mq5uKmiVXoZ+UpSDQ3psO5ZwdF2urJL0rODsp4CG41Oeziqmpu3
EViJkb9LG0seBKUsv9JLKwugl3WBT/E9dxNFwMSlJ+n3fBShbMQeZV8Ba1JwtFo9
W10ywtInm4RYf5UK8VUW
=4CbN
-----END PGP SIGNATURE-----
