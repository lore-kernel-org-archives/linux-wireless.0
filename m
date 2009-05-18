Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:52223 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZERRni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 13:43:38 -0400
Date: Mon, 18 May 2009 19:45:32 +0200
From: Daniel Wagner <wagi@monom.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211_hwsim: Group radios
Message-ID: <20090518174532.GA3886@newton.monom.org>
References: <20090517181911.GA3455@newton.monom.org> <43e72e890905171359q639fe5dco4327187b4fe7909f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890905171359q639fe5dco4327187b4fe7909f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> How about some
> 
> /*
>   * comments heres explaining what a group is too
>   * otherwise one will have to guess by looking at the code
>   */
> > +
> > +       u64 group;
> > +       struct dentry *debugfs_group;
> >  };
> >
> >

Sure. I should have known :) A update is on the way.

thanks!
daniel
