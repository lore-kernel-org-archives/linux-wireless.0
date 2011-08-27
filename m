Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56921 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1H0Kwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 06:52:51 -0400
Received: by gxk21 with SMTP id 21so3545980gxk.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2011 03:52:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314442067-11799-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1314442067-11799-1-git-send-email-rmanohar@qca.qualcomm.com>
Date: Sat, 27 Aug 2011 18:52:50 +0800
Message-ID: <CAJ-Vmo=wLETTSy0i3uz3Zj5w+_o+AouzD=nJzFk9KnERK+g7Cg@mail.gmail.com> (sfid-20110827_125254_040059_243972DB)
Subject: Re: [PATCH] ath9k: Add debugfs support for mac/baseband samples
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 August 2011 18:47, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> This patch keep track of number of samples that includes
> DMA debugs registers, PCU observe, CR, channel noise,
> cycle conters, noisefloor history buffer and last N number
> of tx and rx descriptor status. These samples are grouped

Is this written in a way that makes it easy to conditionally compile
them in/out?



Adrian
