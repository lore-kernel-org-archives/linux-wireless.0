Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:50558 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab0DTXoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 19:44:09 -0400
Received: by pzk42 with SMTP id 42so4584278pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 Apr 2010 16:44:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <j2t69e28c911004201634h41e320bfu2f0746a25f1f0d00@mail.gmail.com>
References: <1271802516-15195-1-git-send-email-lrodriguez@atheros.com>
	<1271802516-15195-3-git-send-email-lrodriguez@atheros.com>
	<j2t69e28c911004201634h41e320bfu2f0746a25f1f0d00@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 20 Apr 2010 16:43:49 -0700
Message-ID: <z2p43e72e891004201643j7c0188a9x5f263493d06bd913@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k_hw: make all AR9002 initvals use u32
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/20 Gábor Stefanik <netrolller.3d@gmail.com>:
> Will the u_int32_t type be removed eventually? (Given that the
> standard type is uint32_t.)

Not sure, but it doesn't matter for us so long as we use u32 :)

  Luis
