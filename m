Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:18222 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZCEBvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 20:51:53 -0500
Received: by wa-out-1112.google.com with SMTP id v33so1944942wah.21
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 17:51:51 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18863.12298.203468.11014@gargle.gargle.HOWL> (sfid-20090305_025157_565007_252978FD)
Date: Thu, 5 Mar 2009 07:21:06 +0530
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: use correct init values for ar9100 devices
In-Reply-To: <49AE96DA.9010208@openwrt.org>
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>
	<18862.1025.217829.656599@gargle.gargle.HOWL>
	<49AE851B.2070709@openwrt.org>
	<18862.36931.112561.497768@gargle.gargle.HOWL>
	<49AE96DA.9010208@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> #define AR_SREV_5416_V20_OR_LATER(_ah) \
> 	(((AR_SREV_5416(_ah)) && \
> 	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)) || \
> 	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
> 
> #define AR_SREV_5416_V22_OR_LATER(_ah) \
> 	(((AR_SREV_5416(_ah)) && \
> 	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22)) || \
> 	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))

Agreed, this is cleaner.

Sujith
