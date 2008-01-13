Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:60090 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbYAMVs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 16:48:56 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1097642fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 13:48:55 -0800 (PST)
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: remove unused variable
Date: Sun, 13 Jan 2008 22:48:47 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20080113194834.677af663@morte> <200801132014.53522.IvDoorn@gmail.com> <20080113201653.2c36391e@morte>
In-Reply-To: <20080113201653.2c36391e@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801132248.47860.IvDoorn@gmail.com> (sfid-20080113_214859_650506_F65C2526)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

> > > Remove an unused variable that caused a warning while building. Please note
> > > that the pipe obtained there isn't used anywhere else.
> > 
> > This patch is in wireless-2.6 already...
> 
> Actually, I thought I already sent this patch, but couldn't find it
> anywhere, neither in my outbox nor in git-log. Could you tell me what's the
> related SHA commit? Thanks.

This is in my rt2x00.git log. It is signed off by John and not by me,
so that means it didn't go through rt2x00.git to get into the wireless tree.
I have merged the patch into rt2x00.git during my last clone from wireless...

commit 01b0258008a73648245dcbc628ff948878c428e0
Author: Stefano Brivio <stefano.brivio@polimi.it>
Date:   Wed Dec 19 01:43:33 2007 +0100

    rt2x00: remove unused variable

    Remove an unused variable. Note that the pipe obtained there isn't used as
    well.

    Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>
