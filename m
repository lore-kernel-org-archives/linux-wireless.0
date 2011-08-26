Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48191 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab1HZJns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 05:43:48 -0400
Received: by pzk37 with SMTP id 37so3985752pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 02:43:48 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 26 Aug 2011 11:43:48 +0200
Message-ID: <CACna6rwzzV=YSkATvLwKk4fcEgtiOjQ9+VihSet_og+y4KkqpA@mail.gmail.com> (sfid-20110826_114351_605449_6C803150)
Subject: 1 more question about sending patches with dependencies
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I want to send patch that depends on
[RFC/RFT] b43: Relax requirement for descriptors to be in the DMA zone

I guess this is already in the John's queue, as Michael asked to apply
it even despite the fact it's RFC/RFT.

Do I have to wait until pushing that patch into wireless-next /
wireless-testing? Or can I just submit my patch? Or should I re-submit
the mentioned patch as part of my patchset?

-- 
Rafał
