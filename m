Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:40285 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaETGGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 02:06:42 -0400
Received: by mail-qg0-f41.google.com with SMTP id j5so4438qga.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 23:06:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <546412005.18351359.1400528308190.JavaMail.root@zimbra65-e11.priv.proxad.net>
References: <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com>
 <546412005.18351359.1400528308190.JavaMail.root@zimbra65-e11.priv.proxad.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Tue, 20 May 2014 08:06:21 +0200
Message-ID: <CAGnRvurBpWcn6ToSVq5bJN=bOuz_8ej9QgcvX6SP97M1ndwCRA@mail.gmail.com> (sfid-20140520_080645_597407_785190B2)
Subject: Re: 802.11s mode without HWMP
To: etienne.champetier@free.fr
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 9:38 PM,  <etienne.champetier@free.fr> wrote:
> Hi,
>
> I'm curious, what are you using for your L3 mesh/can you give details on the network?
>
> Thanks in advance
> Etienne

I am using the Olsr.org codebase for routing... I have spent the last
~2 years to do a clean rewrite of the codebase for an OLSRv2
implementation.

I am not directly involved in one special mesh network.

1st, I am involved in the Olsr.org project, which is one of the
routing protocols used in lots of cities in Europe to build large
city-wide mesh networks with a mixture of wifi links, some of them
with hundreds of nodes.

2nd, I am working for Fraunhofer FKIE in mesh related research
(currently as part of the EU CONFINE project, see
www.confine-project.eu) and we are interested in using mesh networks
both for civil usecases (police, fire brigade, disaster recovery like
earthquakes) and military ones.

Some networks running with OLSR.org routing software have hundreds of
nodes, most are smaller.

My interest in the "bridging adhoc mode" is also related to the IETF
DLEP draft (http://tools.ietf.org/html/draft-ietf-manet-dlep-05),
which contains the concept of the "ethernet attached briding radio"
and a communication protocol between local router and radio.

I think a "802.11s without HWMP" mode would make a perfect candidate
for a DLEP style radio, at the moment I am using IBSS mode and a hack
with the mac addresses.

I hope this answers your question.

Henning Rogge
