Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:52013 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbXH1ULG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 16:11:06 -0400
Received: by wr-out-0506.google.com with SMTP id 36so1386119wra
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2007 13:11:03 -0700 (PDT)
Message-ID: <43e72e890708281311y630b85fcjb132bd065478d760@mail.gmail.com>
Date: Tue, 28 Aug 2007 16:11:03 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
	"Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
In-Reply-To: <20070828171155.GC29343@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2713029743177393055@pripojeni.net>
	 <7515194658758617@pripojeni.net>
	 <20070828171155.GC29343@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/28/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Aug 28, 2007 at 12:00:50PM -0400, Jiri Slaby wrote:
> > ath5k, license is GPLv2
> >
> > The files are available only under GPLv2 since now.
>
> Is this really a good idea?  Most of the reverse-engineering was
> done by the OpenBSD folks, and it would certainly be helpful to
> work together with them on new hardware revisions, etc..

Technically the best we can do is to leave the license as dual
licensed, but keep in that technically that means nothing and is just
for show, the GPL is what would apply as its derivative work and is
the most restrictive license. This applies to any other driver in the
kernel right now with a dual license tag.

  Luis
