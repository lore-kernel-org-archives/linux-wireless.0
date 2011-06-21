Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.calamp.com ([207.71.209.228]:50586 "EHLO MX1.Calamp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1FUNgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 09:36:17 -0400
Received: from oxn-mx1.PD.CalAmpCorp.com ([10.6.0.30]) by MX1.Calamp.com with ESMTP id BDw0bUcb42JYSPzf (version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 06:36:16 -0700 (PDT)
From: =?iso-8859-1?Q?Fr=E9d=E9ric_Lamorce?= <FLamorce@CalAmp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 21 Jun 2011 06:36:13 -0700
Subject: RE: nl80211: set_key failed; err=-67 Link has been severed
Message-ID: <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0D4193ED7D@oxn-mx01.PD.CalAmpCorp.com> (sfid-20110621_153623_416131_948C1C32)
References: <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0D4065B927@oxn-mx01.PD.CalAmpCorp.com>
 <39e83b34879f7b3d79534665e9dd0ae6@secure.sipsolutions.net>
 <8BFC9A1FBD4CFA4FA7496C9F6DBCF4CA0D4193EA50@oxn-mx01.PD.CalAmpCorp.com>
 <20110621054310.GA5538@internetdog.org>
In-Reply-To: <20110621054310.GA5538@internetdog.org>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yup, if I compile wpa_supplicant with CONFIG_DRIVER_NL80211=y, I cannot connect to anything with encryption (WEP, WPA/WPA2), however if I compile with CONFIG_DRIVER_WEXT, everything works.

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Ali Bahar
Sent: June 21, 2011 01:43
To: Frédéric Lamorce
Cc: linux-wireless@vger.kernel.org
Subject: Re: nl80211: set_key failed; err=-67 Link has been severed


Hi Frederic,


On Mon, Jun 20, 2011 at 06:03:11AM -0700, Frédéric Lamorce wrote:
> What I see is that wpa_supplicant only works with wext but it does not work with nl80211.
> My device is an ath9k_htc.

are you suggesting that wpa_supplicant's CONFIG_DRIVER_NL80211
build-option does not fully work?

Just an FYI:
Till yesterday, I had some problems which, while not similar to yours,
involved failures under encryption. You can see my posts in 
http://lists.shmoo.com/pipermail/hostap/2011-June/thread.html
for comparison. Unfortunately, the -dd trace has not been accepted by
that mailing list, yet, due to its size. Perhaps you can check it in a
few days, if it remains of interest to you.

later,
ali
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
