Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:41361 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZEQSSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 14:18:09 -0400
Date: Sun, 17 May 2009 20:19:58 +0200
From: Daniel Wagner <wagi@monom.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: Group radios
Message-ID: <20090517181958.GB3455@newton.monom.org>
References: <20090514204838.GB3225@newton.monom.org> <43e72e890905141434u4c843399jb5355782bacffc0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890905141434u4c843399jb5355782bacffc0e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 02:34:29PM -0700, Luis R. Rodriguez wrote:
> On Thu, May 14, 2009 at 1:48 PM, Daniel Wagner <wagi@monom.org> wrote:
> >
> > Each bit in /debug/ieee80211/phy*/hwsim/group represents one
> > group. By default all radios belong to the same group "1".
> > A radio can belong to several groups.
> 
> What does the grouping do? Might help to add that in the commit log --
> what are they for?

Sure, I have just send an updated version.

thanks,
daniel
