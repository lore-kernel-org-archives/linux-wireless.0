Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [205.233.59.134] ([205.233.59.134]:56997 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1LLKyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 05:54:44 -0500
Subject: Re: [RFC] NFC: Add num of targets to TARGETS_FOUND event
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: "Elias, Ilan" <ilane@ti.com>
Cc: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <B30D1FD582D6484ABF57420512E5803504FD0316@DNCE03.ent.ti.com>
References: <B30D1FD582D6484ABF57420512E5803504FD0316@DNCE03.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 11:59:44 +0100
Message-ID: <1323687584.13722.4.camel@sortiz-mobl> (sfid-20111212_115447_381842_8ED2A61A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Thu, 2011-12-08 at 17:13 +0000, Elias, Ilan wrote:
> I suggest we add a new attribute NFC_ATTR_NUM_TARGETS_FOUND to the event NFC_EVENT_TARGETS_FOUND.
> Otherwise, the user would have to wait until a timeut expires in order to decide that no more targets will arrive.
You mean a timeout from NFC_CMD_GET_TARGET ? You could guess the number
of targets from the dumped message size, couldn't you ?

Cheers,
Samuel.


