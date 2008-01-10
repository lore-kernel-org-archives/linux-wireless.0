Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:23942 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754952AbYAJB3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 20:29:47 -0500
From: bruno randolf <bruno@thinktube.com>
To: Kalle Valo <kalle.valo@nokia.com>
Subject: Re: merge errors on 'everything'
Date: Thu, 10 Jan 2008 10:29:44 +0900
Cc: Pavel Roskin <proski@gnu.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <200801091043.02204.bruno@thinktube.com> <1199845968.3697.22.camel@dv> <87myrf74ix.fsf@nokia.com>
In-Reply-To: <87myrf74ix.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801101029.44985.bruno@thinktube.com> (sfid-20080110_012951_759584_40169321)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 January 2008 18:05:26 Kalle Valo wrote:
> Pavel Roskin <proski@gnu.org> writes:
> >> You'll need to get a fresh clone of the repository -- sorry.
> >
> > While it's reassuring to see that I'm not missing some elegant solution,
> > I think cloning the repository is a major overkill.
>
> I agree.
>
> > "git-reset --hard origin/everything" does the trick for me, while using
> > much less bandwidth and time.
>
> I do the same and it has worked for me, at least.

thanks for that hint, but still, that sucks if you want to rebase your local 
work against an updated 'everything'...

how do you guys manage your pending patches and local work then?

thanks,
bruno
