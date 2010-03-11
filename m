Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:35279 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756737Ab0CKTdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 14:33:50 -0500
Message-ID: <4B9944A0.5080308@redfish-solutions.com>
Date: Thu, 11 Mar 2010 12:29:36 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dunc@lemonia.org, kalle.valo@iki.fi, kaber@trash.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Network QoS support in applications
References: <87my01m0zm.fsf@purkki.valot.fi>	<4B5EF5DF.2070005@lemonia.org>	<4B9942A7.40205@redfish-solutions.com> <20100311.112754.142886660.davem@davemloft.net>
In-Reply-To: <20100311.112754.142886660.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2010 12:27 PM, David Miller wrote:
> From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
> Date: Thu, 11 Mar 2010 12:21:11 -0700
> 
>> And yes, there will always be misbehaving users.  They are a fact of
>> life.  That doesn't mean we should lobotomize the network.  We don't
>> have an authentication mechanism on ICMP Redirects or Source-Quench,
> 
> Which is why most networks block those packets from the outside.
> 
>> Nor is ARP authenticated.
> 
> Which is why people control who can plug into their physical
> network.
> 
> None of the things you are saying support the idea of having
> applications decide what the DSCP marking should be.


Does "decide what the DSCP marking should be" include complying to the recommendations of RFC-4594?

