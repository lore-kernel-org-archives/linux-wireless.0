Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55463 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbZJGFlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 01:41:39 -0400
Received: by mail-iw0-f178.google.com with SMTP id 8so2683907iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 22:41:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890910062045s626777dew4b47fe18bc8d9aee@mail.gmail.com>
References: <1254886762-17211-1-git-send-email-HinTak.Leung@gmail.com>
	<3ace41890910062045s626777dew4b47fe18bc8d9aee@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 7 Oct 2009 01:41:08 -0400
Message-ID: <43e72e890910062241k3c4660eaobbcee4456485be93@mail.gmail.com>
Subject: Re: [PATCH] compat-2.6: adding ethtool.h to compat-2.6.31.h
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 6, 2009 at 11:45 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:

> warning: type defaults to ‘int’ in declaration of ‘SIMPLE_DEV_PM_OPS’

Yeah we need to backport this stuff, it seems all drivers are intended
to be moved to use these simple dev pm ops so we might as well.

  Luis
