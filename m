Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51875 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYJONXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 09:23:43 -0400
Date: Wed, 15 Oct 2008 09:20:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas : Remove unused variable warning
	"old_channel" from drivers/net/wireless/libertas/cmd.c
Message-ID: <20081015132053.GA27688@tuxdriver.com> (sfid-20081015_152348_778661_8F7E6957)
References: <ea11fea30810130352i3cea0579g9950289254c8e628@mail.gmail.com> <1224002213.1799.2.camel@localhost.localdomain> <ea11fea30810150110s772b740fv38cc37645da53201@mail.gmail.com> <1224060475.27537.0.camel@johannes.berg> <ea11fea30810150201i6f5649dyd6da42c4f7cdcb01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ea11fea30810150201i6f5649dyd6da42c4f7cdcb01@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 02:31:37PM +0530, Manish Katiyar wrote:
> On Wed, Oct 15, 2008 at 2:17 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > [dropping libertas list, subscribers only]
> >
> > On Wed, 2008-10-15 at 13:40 +0530, Manish Katiyar wrote:
> >> On Tue, Oct 14, 2008 at 10:06 PM, Dan Williams <dcbw@redhat.com> wrote:
> >> > On Mon, 2008-10-13 at 16:22 +0530, Manish Katiyar wrote:
> >> >> Below patch removes the following warning during compilation.
> >> >>
> >> >> drivers/net/wireless/libertas/cmd.c:826: warning: unused variable 'old_channel'
> >> >>
> >> >>
> >> >> Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
> >> >
> >> > Acked-by: Dan Williams <dcbw@redhat.com>
> >>
> >> Hi Dan,
> >>
> >> A newbie question. Will you merge this patch or will I have to send it
> >> to Andrew again acked by you ?
> >
> > John has already applied it, Andrew isn't typically involved with
> > wireless.
> 
> Thanks a lot John.

No, thank you! :-)

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
