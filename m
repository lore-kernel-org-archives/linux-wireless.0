Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:13143 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZENVes (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 17:34:48 -0400
Received: by wf-out-1314.google.com with SMTP id 26so939124wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 14:34:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090514204838.GB3225@newton.monom.org>
References: <20090514204838.GB3225@newton.monom.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 May 2009 14:34:29 -0700
Message-ID: <43e72e890905141434u4c843399jb5355782bacffc0e@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: Group radios
To: Daniel Wagner <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 1:48 PM, Daniel Wagner <wagi@monom.org> wrote:
>
> Each bit in /debug/ieee80211/phy*/hwsim/group represents one
> group. By default all radios belong to the same group "1".
> A radio can belong to several groups.

What does the grouping do? Might help to add that in the commit log --
what are they for?

 Luis
