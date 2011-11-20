Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33368 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1KTOgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 09:36:18 -0500
Received: by bke11 with SMTP id 11so5434114bke.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 06:36:17 -0800 (PST)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFC] p54spi: don't DMA onto the stack
Date: Sun, 20 Nov 2011 18:36:12 +0400
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
References: <20111116235120.4c60c066@milhouse> <201111200448.55662.jcmvbkbc@gmail.com> <201111201424.41956.chunkeey@googlemail.com>
In-Reply-To: <201111201424.41956.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201111201836.13114.jcmvbkbc@gmail.com> (sfid-20111120_153626_837321_06DD2B5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Ok, that's a dead end then. BTW, what's your opinion on the subject. Should
> we alloc a bufffer on demand or have one which is "big enough" always
> around?

The latter seems to me a bit better w.r.t. amount of work on the fast path (:

Thanks.
-- Max
