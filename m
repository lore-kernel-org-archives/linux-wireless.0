Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64299 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZFRDEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 23:04:49 -0400
Received: by ewy6 with SMTP id 6so1114675ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 20:04:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245293606-2101-1-git-send-email-HinTak.Leung@gmail.com>
References: <1245293606-2101-1-git-send-email-HinTak.Leung@gmail.com>
Date: Thu, 18 Jun 2009 04:04:50 +0100
Message-ID: <3ace41890906172004r6574e4fet4b797669e92cad1b@mail.gmail.com>
Subject: Re: [PATCH 1/2] zd1211rw: sort vid/pid pairs by numerical value
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2009 at 3:53 AM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> In the past ids were inserted in no particular order and it has
> become hard to see what ids are already included or not. This
> patch sorts the ids by numerical value and has no functional effect.
>
> Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>

There is no [PATCH 2/2] - sorry - Please treat "[PATCH 1/2]" as standalone.
