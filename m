Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:26860 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaESTia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:38:30 -0400
Date: Mon, 19 May 2014 21:38:28 +0200 (CEST)
From: etienne.champetier@free.fr
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <546412005.18351359.1400528308190.JavaMail.root@zimbra65-e11.priv.proxad.net> (sfid-20140519_213833_285018_3E71F7BF)
In-Reply-To: <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com>
Subject: Re: 802.11s mode without HWMP
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

----- Mail original -----
> De: "Henning Rogge" <hrogge@gmail.com>
> À: "Bob Copeland" <me@bobcopeland.com>
> Cc: linux-wireless@vger.kernel.org
> Envoyé: Lundi 19 Mai 2014 16:14:36
> Objet: Re: 802.11s mode without HWMP
> 
> On Mon, May 19, 2014 at 3:18 PM, Bob Copeland <me@bobcopeland.com>
> wrote:
> > On Mon, May 19, 2014 at 11:00:53AM +0200, Henning Rogge wrote:
> >> Is there an easy way to stop HWMP in the 802.11s implementation?
> >

> I have an IP router connected via ethernet to a radio with a single
> wifi card, using the wifi card as a bridged radio. Its a great way to
> build routers with lots of Wifi links because you can mount the
> wifi-cards itself on the antenna and keep the router in a central
> place.
> 
> I don't want to use layer-2 forwarding in the mesh because this
> increases the broad-/multicast domain size and spams the available
> frequencies even more.

> 
> I want to force 802.11s only to connect to other stations one layer-2
> hop away. So no forwarding by intermediate stations.
> 
> Henning Rogge
> --

I'm curious, what are you using for your L3 mesh/can you give details on the network?

Thanks in advance
Etienne
