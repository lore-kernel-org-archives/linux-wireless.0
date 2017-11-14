Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:8911 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756099AbdKNRia (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 12:38:30 -0500
From: Peng Xu <pxu@qti.qualcomm.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Sara Sharon" <sara.sharon@intel.com>
Subject: RE: [RFC] cfg80211: Implement Multiple BSSID capability in scanning
Date: Tue, 14 Nov 2017 17:38:26 +0000
Message-ID: <59a37842482b40ceb5e60c2155bca78c@NASANEXM01F.na.qualcomm.com> (sfid-20171114_184050_261011_A7AA8CBA)
References: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com>
 <1510664296.2030.22.camel@sipsolutions.net>
 <4927d2288442486788cd5b4d0492537a@NASANEXM01F.na.qualcomm.com>
 <1510669408.2030.23.camel@sipsolutions.net>
 <929d1fdb74524aeaab4959f84a82c732@NASANEXM01F.na.qualcomm.com>
 <1510669995.2030.26.camel@sipsolutions.net>
 <e540b35f76a447cab35f7267c09ee8f5@NASANEXM01F.na.qualcomm.com>
 <20171114163127.GA24453@jouni.qca.qualcomm.com>
In-Reply-To: <20171114163127.GA24453@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, Nov 14, 2017 at 02:39:31PM +0000, Peng Xu wrote:
> > > I'm not even sure why this is necessary anyway though, do we really
> > > think vendors will expect to be able to put vendor IEs inside the
> > > subelements and override the ones outside?
> > >
> > > Is there even any point for the WFA ones? It seems WMM really ought
> > > to be the same for all anyway, for example.
> >
> > I don't have any use case for such scenario. If vendor elements are
> > unlikely to be present in subelement, this logic can be removed.
>=20
> As far as WMM element is concerned, I'd note that IEEE 802.11 standard do=
es
> not list EDCA Parameter Set element as one of the items that has to be sa=
me
> for all the BSSs in a multiple BSSID set and as such, I'd consider it to =
be
> allowed behavior for an AP to advertise different WMM parameters for
> different nontransmitted BSSIDs.
>=20
> As far as other vendor specific elements are concerned, there could certa=
inly
> be use cases for using different values for WPA element, Hotspot 2.0
> element, MBO/OCE element.
>=20
Hi Jouni,
As you pointed out the use cases for having vendor elements in MBSSID subel=
ements, what is
your suggestion to identify and process the vendor elements?=20

Thanks,
Peng
