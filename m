Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55637 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1HQLeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 07:34:17 -0400
Received: by pzk37 with SMTP id 37so944149pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 04:34:16 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Aug 2011 13:34:16 +0200
Message-ID: <CACna6rzdgENO-fCmm8tTVpuk_M7A88C7HgSGmTsjF3U8ZxDbYQ@mail.gmail.com> (sfid-20110817_133420_518029_C5D38BD7)
Subject: Question about versions: wl vs. brcmsmac
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: brudley@broadcom.com, henryp@broadcom.com, rvossen@broadcom.com,
	arend@broadcom.com, frankyl@broadcom.com, kanyan@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Broadcom,

I've compare dump from wl with dump from brcmsmac and noticed some differences.

Some random ones for LCN PHY:
1) brcmsmac doesn't touch 0x663 register in PHY init
2) wl uses 0xfedb, brcmsmac uses 0xfe4b as some value for 0xb table
3) brcmsmac uses 0x3 instead 0x0 for radio reg 0x38
and so on...

My question is, which driver includes newer (more correct I hope) code?

I'm comparing brcmsmac from git with wl 5.100.82.38.

-- 
Rafał
