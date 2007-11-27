Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.235]:41474 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbXK0QGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 11:06:55 -0500
Received: by nz-out-0506.google.com with SMTP id s18so773151nze
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 08:06:54 -0800 (PST)
Message-ID: <1ba2fa240711270806s5aa93418md0cd25d7519ae3d7@mail.gmail.com> (sfid-20071127_160700_628617_8B48A612)
Date: Tue, 27 Nov 2007 18:06:52 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH (2.6.24) 0/3] last minute iwlwifi fixes
Cc: "John Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Ian Schram" <ischram@telenet.be>
In-Reply-To: <1196179471.6058.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071126225416.467939000@sipsolutions.net>
	 <1ba2fa240711270654r276657ch4e56e543a3c4a427@mail.gmail.com>
	 <1196175476.6058.25.camel@johannes.berg>
	 <1ba2fa240711270800p3312246as51b0a23f77e81f3@mail.gmail.com>
	 <1196179471.6058.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sorry for stupid question but what is the git for 24.?

On Nov 27, 2007 6:04 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2007-11-27 at 18:00 +0200, Tomas Winkler wrote:
>
> > I found it, there was a patch by Ian Schram <ischram@telenet.be>
> > '[PATCH] allow changing mac_addr by userspace'
> > It should work I nacked it just because I wanted to remove a filed he
> > was using, it never happened so I think we can apply it
> > for 24 and then I get back to rework it.
> > I'll resend it rebased to current everything.
>
> Great, thanks. Actually, John will probably prefer if you send him a
> version against .24 as well. John, please drop 2 and 3 of this series
> then in favour of that patch.
>
> johannes
>
