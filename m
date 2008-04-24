Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:24352 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbYDXGsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 02:48:40 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Roaming problems
Date: Thu, 24 Apr 2008 08:45:41 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	Lars Ericsson <Lars_Ericsson@telia.com>,
	"'Johannes Berg'" <johannes@sipsolutions.net>,
	hostap@lists.shmoo.com
References: <004201c8a55e$f4668f10$0b3ca8c0@gotws1589> <1208968274.24395.10.camel@localhost.localdomain> <20080423204704.GA30048@tuxdriver.com>
In-Reply-To: <20080423204704.GA30048@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804240845.41867.hs4233@mail.mn-solutions.de> (sfid-20080424_084939_259592_35BD0027)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm not disputing that as a reasonable approach.  But FWIW for
> two years we've been saying it is OK for drivers to use
> setting SSID as the only trigger for association.  Is that not
> your understanding?

I have a patch for better-reassociation-for-libertas, where both 
SIWESSID or SIWAP trigger an re-association --- but with a delay 
of some hundred milliseconds. Works great with with iwconfig and 
wpa_supplicant.

(However, I won't share this patch yet because it is completely 
AdHoc-agnostic).
