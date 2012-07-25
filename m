Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63349 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2GYWbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 18:31:13 -0400
Received: by obbuo13 with SMTP id uo13so1718575obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 15:31:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50106C9F.3050504@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<CAFtRNNx+YgGgFp_owGQJcsQVqTuOeWk2J0MwjKMtcUgRq_DF0w@mail.gmail.com>
	<50106C9F.3050504@net.t-labs.tu-berlin.de>
Date: Thu, 26 Jul 2012 01:31:12 +0300
Message-ID: <CAFtRNNw-EuLRouL6dGnzSmc=paP=SAFUj3XqVo8-jLKBJZBBdw@mail.gmail.com> (sfid-20120726_003121_116095_EB0A497F)
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix wrong per rate target power
 eeprom reads for AR5K_EEPROM_MODE_11A
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: jirislaby@gmail.com, johannes.berg@intel.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, nbd@nbd.name
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/26 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> Hi Nick,
>
> [...]
>
> The calibration data for 802.11a in the standard conform mode should
> only consider 8 reads from the eeprom, thats why I introduced this new
> define... a "-3" is from my view of readability not as traceable.
> Any other non standard mode as you mentioned XR as one of, could just
> ready its necessary lines of the eeprom ones it get supported in ath5k.
>
> Greetings Thomas

Sorry for the mess Thomas, guess I should start trusting the docs etc
I have and leave rev. engineering mode from now on :P

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
