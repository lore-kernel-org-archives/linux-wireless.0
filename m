Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.237]:55200 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbXIZLzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 07:55:32 -0400
Received: by nz-out-0506.google.com with SMTP id s18so1431802nze
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2007 04:55:31 -0700 (PDT)
Message-ID: <1ba2fa240709260455x1873bf11v4d859801b384841d@mail.gmail.com>
Date: Wed, 26 Sep 2007 13:55:30 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>, davem@davemloft.net
Subject: Re: [PATCH 1/1] mac80211: add sta_notify callback
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1190622867.18521.232.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1190036530108-git-send-email-tomas.winkler@intel.com>
	 <1190197117.4414.0.camel@johannes.berg>
	 <1ba2fa240709190438o5032df52mb22a97546bdbe563@mail.gmail.com>
	 <1190204934.4414.17.camel@johannes.berg>
	 <1ba2fa240709190805i6b703e0w885390a78eda9bdc@mail.gmail.com>
	 <1190214671.4414.24.camel@johannes.berg>
	 <1ba2fa240709220933n5783a08coeac2057b6b7da083@mail.gmail.com>
	 <1ba2fa240709231644l17001fb5ne531674f5b8722fd@mail.gmail.com>
	 <1ba2fa240709231747w6236dd32vb7186a16bc7a6b7c@mail.gmail.com>
	 <1190622867.18521.232.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-09-24 at 02:47 +0200, Tomas Winkler wrote:
>
> > git:// works fine but I need http because of the firewall.
>
> Michael: poke: you need to run git-http-update or whatever it's called
> from the commit hook.
>
Actually the problem is in net-2.6.24.git which mac80211-misc references
Dave?

Thanks
Tomas

>
>
