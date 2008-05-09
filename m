Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:42686 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbYEIVXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 17:23:16 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1756882rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2008 14:23:16 -0700 (PDT)
Message-ID: <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com> (sfid-20080509_232321_230305_8048F9FF)
Date: Sat, 10 May 2008 00:23:15 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vincent C Jones" <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 9, 2008 at 7:57 PM, Vincent C Jones
<v.jones@networkingunlimited.com> wrote:
> The channel/frequency reporting by iwlwifi is incompatible with
>  wpa_supplicant for 5GHz (802.11A) channels. Version numbers and iwlist
>  versus wpa_supplicant scan results are below. Association still works if
>  the correct channel is specified using iwconfig, but that is
>  incompatible with roaming.

Fixed by the patch ' iwlwifi: Fix frequency in rx_status fill'

Thanks
Tomas
