Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45568 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DMR4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 13:56:09 -0400
Received: by gyg13 with SMTP id 13so3601562gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 10:56:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87k4sbnvgo.fsf@purkki.valot.fi>
References: <1271110918-18599-1-git-send-email-notasas@gmail.com>
	 <87k4sbnvgo.fsf@purkki.valot.fi>
Date: Tue, 13 Apr 2010 13:56:08 -0400
Message-ID: <g2lb6c5339f1004131056v597857c0qf0da0dd093d6dbfa@mail.gmail.com>
Subject: Re: [PATCH] wl1251: register platform_device to pass board data
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 13, 2010 at 12:55 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> However there is no way to pass this data through SDIO subsystem, so
>> this patch registers dummy platform_device to allow that.

No objection to the patch, platforms like android want this so
you can set the gpio for irq handling instead of using the
SDIO interrupts.

But maybe we should invent a way to send it through the SDIO
subsystem?

My hope was that device trees on ARM would solve the issue
eventually.

-- 
Bob Copeland %% www.bobcopeland.com
