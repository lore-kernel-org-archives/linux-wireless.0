Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35925 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1LLQkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 11:40:39 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Samuel Ortiz <samuel@sortiz.org>
CC: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] NFC: Add num of targets to TARGETS_FOUND event
Date: Mon, 12 Dec 2011 16:40:22 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803504FD0D29@DNCE03.ent.ti.com> (sfid-20111212_174042_410125_646CAD48)
References: <B30D1FD582D6484ABF57420512E5803504FD0316@DNCE03.ent.ti.com>
 <1323687584.13722.4.camel@sortiz-mobl>
In-Reply-To: <1323687584.13722.4.camel@sortiz-mobl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel, 

> > I suggest we add a new attribute NFC_ATTR_NUM_TARGETS_FOUND 
> to the event NFC_EVENT_TARGETS_FOUND.
> > Otherwise, the user would have to wait until a timeut 
> expires in order to decide that no more targets will arrive.
> You mean a timeout from NFC_CMD_GET_TARGET ? You could guess 
> the number
> of targets from the dumped message size, couldn't you ?
As you said (in the NFC IRC room), the last dump message should be marked with NLMSG_DONE.
I'll check it out.

Thanks & BR,
Ilan