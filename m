Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:21064 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab1EJFl3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 01:41:29 -0400
Subject: Re: Wireless-regdb US and CA settings incorrect?
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Michael Green <Michael.Green@Atheros.com>
Cc: "ext Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ext John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
In-Reply-To: <1305003469.3749.118.camel@wimaxnb>
References: <93781E992CBA7843962D8B0E7D683F3C1700646FD6@SC1EXMB-MBCL.global.atheros.com>
	 <1305003469.3749.118.camel@wimaxnb>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 08:40:30 +0300
Message-ID: <1305006030.3749.129.camel@wimaxnb> (sfid-20110510_074132_785982_5AD7132D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-10 at 07:57 +0300, Juuso Oikarinen wrote:
> On Mon, 2011-05-09 at 06:31 -0700, ext Michael Green wrote:
> > 1) Canada:    Industry Canada allows STAs to passive scan (ie enable operation) in those weather radar channels (5.6 to 5.65 GHz).  
> > APs must disable operation in those channels in Canada.  
> > 
> > 2) U.S.:  I hope the entire industry (including Open Source) is aware and understands latest FCC rules for this band (attached "interim rules").    Here again, APs must disable operation in those channels and follow other restrictions about usage and installation, warnings to installers as described in this attachment.
> > STAs in US are not subject to these restrictions.
> > 
> > 3) Atheros licensed software has two different reg domains for some countries like U.S. to support this case (ie different channels sets for AP vs. STA for the same country).
> > 
> > 
> > And somewhat related note:  in future when peer to peer technologies are supported in open source, then we need to be careful that sw and hw complies with these same rules (when a client device acts like a  "Master" per FCC definition using radar channels, then it must meet the full AP/DFS rules).  This point is not directly related to above Q&A, but thought I would mention it now.
> > 
> 
> Thanks a lot for the clarification.

One more thing though. For 1), I cannot find these interim rules
anywhere, can you post me a reference?

While I agree with what is said, but I still have the understanding that
if there is a non-conforming AP transmitting on the weather radar
frequencies within Canada, the STA still should refrain from
transmissions.

-Juuso

> -Juuso
> 
> > 
> > Michael Green
> > Atheros Communications, Inc.
> > mgreen@atheros.com
> > Desk:   +1-781-400-1491
> > Mobile: +1-508-380-4921
> > 
> > -----Original Message-----
> > From: Juuso Oikarinen [mailto:juuso.oikarinen@nokia.com] 
> > Sent: Monday, May 09, 2011 6:29 AM
> > To: ext Luis R. Rodriguez
> > Cc: Michael Green; ext John W. Linville; linux-wireless@vger.kernel.org; wireless-regdb@lists.infradead.org
> > Subject: Re: wireless-regdb US and CA settings incorrect?
> > 
> > On Thu, 2011-05-05 at 08:57 -0700, ext Luis R. Rodriguez wrote:
> > > On Thu, May 5, 2011 at 4:21 AM, Juuso Oikarinen 
> > > <juuso.oikarinen@nokia.com> wrote:
> > > > Hi John, all,
> > > >
> > > > The following is an excerpt of the db.txt from most recent 
> > > > wireless-regdb.
> > > >
> > > > country US:
> > > >         (2402 - 2472 @ 40), (3, 27)
> > > >         (5170 - 5250 @ 40), (3, 17)
> > > >         (5250 - 5330 @ 40), (3, 20), DFS
> > > >         (5490 - 5600 @ 40), (3, 20), DFS
> > > >         (5650 - 5710 @ 40), (3, 20), DFS
> > > >         (5735 - 5835 @ 40), (3, 30)
> > > >
> > > > country CA:
> > > >         (2402 - 2472 @ 40), (3, 27)
> > > >         (5170 - 5250 @ 40), (3, 17)
> > > >         (5250 - 5330 @ 40), (3, 20), DFS
> > > >         (5490 - 5710 @ 40), (3, 20), DFS
> > > >         (5735 - 5835 @ 40), (3, 30)
> > > >
> > > > We are under the understanding that the Canadian national rules deny 
> > > > the usage of the 5490-5710 range of frequencies (ref from RSS-210), 
> > > > but the range is present in the allowed range of frequencies for the CA region:
> > > >
> > > > "Additional requirements for the band 5600-5650 MHz: Until further 
> > > > notice, devices subject to this Section shall not be capable of 
> > > > transmitting in the band 5600-5650 MHz, so that Environment Canada 
> > > > weather radars operating in this band are protected."
> > > >
> > > > Then again, the FCC rules (15.407) do not prohibit the mentioned 
> > > > range of frequencies within the US (with DFS and limited power 
> > > > level) but in the regulatory database that range is missing.
> > > >
> > > >
> > > > Is there a bug in the regulatory db, or am I misunderstanding something?
> > > 
> > > 
> > > Michael, any opinion on this?
> > 
> > Any take on this one?
> > 
> > -Juuso
> > 
> > 
> 


