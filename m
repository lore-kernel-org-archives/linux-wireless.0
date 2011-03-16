Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61436 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1CPSvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 14:51:08 -0400
Received: by iwn34 with SMTP id 34so1967288iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 11:51:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D8104FE.4030700@free.fr>
References: <4D8104FE.4030700@free.fr>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 16 Mar 2011 11:50:48 -0700
Message-ID: <AANLkTikfR+hr6O+vjqRBsJ5e5sN4xC00sjUhHaBXBwu1@mail.gmail.com>
Subject: Re: can not compile ath9k driver for ubuntu 2.6.38-6-generic kernel
To: Le Gluon du Net <legluondunet@free.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 11:44 AM, Le Gluon du Net <legluondunet@free.fr> wrote:
> /home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.c:
> In function ‘tty_set_termios’:
> /home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.c:93:4:
> error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
> /home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.c:93:4:
> note: each undeclared identifier is reported only once for each function

This looks like the same problem that cropped up on iwlwifi 32-bit
last week.  That file is probably missing an include for linux/sched.h


Dan
