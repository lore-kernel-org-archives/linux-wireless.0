Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60645 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1HLOCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 10:02:22 -0400
Received: by pzk37 with SMTP id 37so1205550pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 07:02:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
Date: Fri, 12 Aug 2011 16:02:22 +0200
Message-ID: <CACna6rztueomzzas=hQjfj6htD=SHFhrtFPSqbviqVDwaihJ9w@mail.gmail.com> (sfid-20110812_160228_875140_9B786C0C)
Subject: Re: [PATCH 00/14] staging: brcm80211: brcmfmac driver cleanup
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/12 Arend van Spriel <arend@broadcom.com>:
> Several cleanup patches to reduce code for the brcmfmac driver and
> get rid of a remaining checkpatch warning. The driver sources should
> be clear from checkpatch issue now.
>
> This series applies to staging-next and depends on the following patch set:

Are you testing patches on some hardware? Or just compile-testing?

I believe this driver is meant to support BCM4329, which is not PCI(e)
board. What adapter do you use?

I've heard about Arasan adapter. Have you tried it? Is that something
reachable from arasan.com?

-- 
Rafał
