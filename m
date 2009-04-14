Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:52792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751835AbZDNAxJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 20:53:09 -0400
Date: Mon, 13 Apr 2009 17:40:38 -0700
From: Greg KH <greg@kroah.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090414004037.GA31049@kroah.com> (sfid-20090414_025314_296358_2CC72DDB)
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> <20090320131014.GG25237@storm.local.network> <20090414000835.GA31504@storm.local.network> <43e72e890904131712y55ba7f16sa8cb568128afeaeb@mail.gmail.com> <20090414002246.GB31504@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090414002246.GB31504@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 08:22:46PM -0400, Forest Bond wrote:
> Hi,
>=20
> On Mon, Apr 13, 2009 at 05:12:02PM -0700, Luis R. Rodriguez wrote:
> > On Mon, Apr 13, 2009 at 5:08 PM, Forest Bond <forest@alittletooquie=
t.net> wrote:
> > > Hi,
> > >
> > > On Fri, Mar 20, 2009 at 09:10:15AM -0400, Forest Bond wrote:
> > >> On Thu, Mar 19, 2009 at 09:45:19AM -0700, Luis R. Rodriguez wrot=
e:
> > >> > On Thu, Mar 19, 2009 at 9:42 AM, Forest Bond <forest@alittleto=
oquiet.net> wrote:
> > >> > > Hi,
> > >> > >
> > >> > > VIA has released a new version of the VT6656 driver source, =
and it now has a
> > >> > > proper license!
> > >> > >
> > >> > > =A0http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_=
x86.zip
> > >> > >
> > >> > > As you may recall, the previous version lacked a license alt=
ogether, making it
> > >> > > unfit for distribution.
> > >> > >
> > >> > > I'd really like to see this driver integrated into the kerne=
l. =A0Does anyone care
> > >> > > to comment regarding feasibility?
> > >> >
> > >> > Indeed good news, what is the latest kernel it compiles for? I=
f it
> > >> > compiles on Linus' tree it can be stashed into staging while i=
t gets
> > >> > properly ported.
> > >>
> > >> Just so I know who to pester*, will you be driving this? =A0Do y=
ou have interest
> > >> in also pulling in the VT6655 driver?
> > >>
> > >> * I won't pester that much. ;)
> > >
> > > I'm getting the sense that there is not a lot of developer intere=
st in these
> > > drivers. =A0Is there anything I can do to aid in getting these dr=
ivers into the
> > > kernel?
> > >
> > > I would be willing to send patches, however, my experience with k=
ernel hacking
> > > is limited and I don't have a lot of time available to contribute=
=2E =A0With a
> > > little direction, though, I might be able to get somewhere.
> > >
> > > Any input would be appreciated.
> > >
> >=20
> > Best thing is to stash them into staging and hope someone will be
> > interested in porting it.
>=20
> Would it be helpful if I sent patches that do nothing more than add t=
he source
> files as they exist currently to staging, or is there more that needs=
 to happen
> for the source files to be appropriate for inclusion there?

That would be a good start, I can take it from there.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
