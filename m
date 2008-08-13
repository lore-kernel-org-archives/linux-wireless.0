Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.229]:53800 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYHMQjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 12:39:12 -0400
Received: by wx-out-0506.google.com with SMTP id h29so95600wxd.4
        for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2008 09:39:12 -0700 (PDT)
Message-ID: <43e72e890808130939s1e35344cw524a0da13756f603@mail.gmail.com> (sfid-20080813_183917_663840_352ACCCF)
Date: Wed, 13 Aug 2008 09:39:12 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Artjom <engine80@bk.ru>
Subject: Re: Question
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1218613730.11607.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1218613730.11607.8.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 13, 2008 at 12:48 AM, Artjom <engine80@bk.ru> wrote:
> No possible to load compat-wireless modules in Fedora 8. What to do?
> What is the reason?
> The same with kernel 2.6.26.2-2.fc8.

You must do

make unload

first. Did you do that? And no need to do make load, just modprobe the
module of the wireless driver you need.

  Luis
