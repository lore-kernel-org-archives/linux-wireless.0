Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:52876 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEGUDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 16:03:22 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so2149887lbi.15
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 13:03:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140507195435.GF20432@tuxdriver.com>
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com> <20140507195435.GF20432@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Wed, 7 May 2014 13:03:00 -0700
Message-ID: <CAB=NE6XLnK-YKigXs8-R-H72rDJ6oDyChQhRLFcqzchFgO+BZA@mail.gmail.com> (sfid-20140507_220325_150275_83A846E5)
Subject: Re: [ath9k-devel] [PATCH] ath9k: fix NULL-deref in
 hw_per_calibration() for ar9002
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Herrmann <dh.herrmann@gmail.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	ath9k mailing list <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 7, 2014 at 12:54 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Is there any hope for getting a more complete fix from the ath9k guys
> in short order?

Wait, who are the ath9k folks now exactly ?

  Luis
