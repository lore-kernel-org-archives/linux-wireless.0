Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37014 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbYFQSI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:08:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [RFC PATCH 3/7] 802.11w: Add BIP (AES-128-CMAC)
Date: Tue, 17 Jun 2008 20:08:34 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <20080617154008.883383150@localhost> <1213721714.3803.83.camel@johannes.berg> <20080617180610.GC4974@jm.kir.nu>
In-Reply-To: <20080617180610.GC4974@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806172008.35163.mb@bu3sch.de> (sfid-20080617_200900_721778_3D414A7F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 June 2008 20:06:10 Jouni Malinen wrote:
> > Since you say the struct is packed you should be able to use __le16 just
> > fine.
> 
> Is that guaranteed to force all accesses of the field to not use 16-bit
> read/write?

Yes.

-- 
Greetings Michael.
