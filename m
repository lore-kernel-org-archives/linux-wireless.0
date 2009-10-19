Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:35810 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbZJSPuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 11:50:21 -0400
Received: by yxe26 with SMTP id 26so3750496yxe.4
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 08:50:26 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 Oct 2009 11:50:25 -0400
Message-ID: <86201b3f0910190850g3f014abbi9e2fa3f89463e7c6@mail.gmail.com>
Subject: How do you set the rate algorithm from the command line
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using mac80211 in an embedded system.  I can build the driver so
that more than one wifi rate algorithm is included, and one is set as
the default.  It is not clear to me how to set the rate algorithm at
run time.  Is there a command line utility that does this?

Suppose I build the driver so that both the PID and Mistrel algorithms
are included, and the Minstrel algorithm is the default.  How can I
switch to the PID algorithm at run time?

Thanks for your help.
