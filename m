Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:42269 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaFRXet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 19:34:49 -0400
Received: by mail-la0-f51.google.com with SMTP id mc6so964346lab.24
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2014 16:34:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402469724-22358-4-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com> <1402469724-22358-4-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 18 Jun 2014 16:34:27 -0700
Message-ID: <CAB=NE6XTgcMWNHppF7WgZjqGCyaZSOJLF4FUC1hwVyyaBrJ79g@mail.gmail.com> (sfid-20140619_013452_437916_D22F49AB)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> Allow driver and user hints to set the "world" regulatory domain,

NACK - as expressed in the other patch, letting the drivers to use the
new API to set the world regulatory domain doesn't make sense as we
have custom apply stuff, and the world regulatory domain is not
something dynamic.

  Luis
