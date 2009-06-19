Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f186.google.com ([209.85.210.186]:63119 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZFSXnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 19:43:00 -0400
Received: by yxe16 with SMTP id 16so24571yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 16:43:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A3C2036.6060506@gmail.com>
References: <4A3C2036.6060506@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Jun 2009 16:42:42 -0700
Message-ID: <43e72e890906191642kbcca090we1b03db19bf0e2c8@mail.gmail.com>
Subject: Re: iwl3945 not working after recent commits
To: Darren Blaber <dmbtech@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 4:33 PM, Darren Blaber<dmbtech@gmail.com> wrote:
> Not sure which commit broke it, but using latest compat-wireless, I get
> this:
>

> Jun 17 19:17:11 pi kernel: [330532.746391] iwl3945 0000:0c:00.0: Failed to
> register hw (error -17)

Try now, I just updated the tarball with John's latest applied patches
on wireless-testing.

v2.6.30-26871-g25e4fbe
wireless-testing latest tag:
master-2009-06-19
This is compat-release:
master-2009-06-15-2-ged8e599

  Luis
