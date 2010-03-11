Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39243
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756485Ab0CKT1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 14:27:36 -0500
Date: Thu, 11 Mar 2010 11:27:54 -0800 (PST)
Message-Id: <20100311.112754.142886660.davem@davemloft.net>
To: philipp_subx@redfish-solutions.com
Cc: dunc@lemonia.org, kalle.valo@iki.fi, kaber@trash.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Network QoS support in applications
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B9942A7.40205@redfish-solutions.com>
References: <87my01m0zm.fsf@purkki.valot.fi>
	<4B5EF5DF.2070005@lemonia.org>
	<4B9942A7.40205@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Date: Thu, 11 Mar 2010 12:21:11 -0700

> And yes, there will always be misbehaving users.  They are a fact of
> life.  That doesn't mean we should lobotomize the network.  We don't
> have an authentication mechanism on ICMP Redirects or Source-Quench,

Which is why most networks block those packets from the outside.

> Nor is ARP authenticated.

Which is why people control who can plug into their physical
network.

None of the things you are saying support the idea of having
applications decide what the DSCP marking should be.
