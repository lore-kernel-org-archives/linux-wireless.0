Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49220 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967342AbeBNLa6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 06:30:58 -0500
Message-ID: <1518607856.21268.3.camel@sipsolutions.net> (sfid-20180214_123101_836136_1B700D0E)
Subject: Re: Max clients on wifi access point with 7265
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Micka=EBl?= PANNEQUIN <m.pannequin@xperteam.fr>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 14 Feb 2018 12:30:56 +0100
In-Reply-To: <HE1PR0501MB23969FCE58F1EE7634D412F0F6F50@HE1PR0501MB2396.eurprd05.prod.outlook.com> (sfid-20180214_115522_052706_6AECF2E4)
References: <HE1PR0501MB23969FCE58F1EE7634D412F0F6F50@HE1PR0501MB2396.eurprd05.prod.outlook.com>
         (sfid-20180214_115522_052706_6AECF2E4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-02-14 at 10:55 +0000, Mickaël PANNEQUIN wrote:
 
> Do you know the limit of the number of users connected at the same
> time on the wifi? Works fine with 14 connected devices but not more.
> 
> How to increase it?

You can't.

> This limit is hardware?

More or less, yes. The HW/FW can support 16 STAs, but needs two for
other bookkeeping.

johannes
