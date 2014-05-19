Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:37563 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaESOaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 10:30:09 -0400
Received: by mail-ie0-f179.google.com with SMTP id rd18so2224480iec.10
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 07:30:08 -0700 (PDT)
Date: Mon, 19 May 2014 10:29:59 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 802.11s mode without HWMP
Message-ID: <20140519142959.GB6198@localhost> (sfid-20140519_163013_495743_E599A789)
References: <CAGnRvurDvRqeNZYHZQG63=6FQv2XnFOR+J9K4-Dk=F77c6SdKQ@mail.gmail.com>
 <20140519131832.GA6198@localhost>
 <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGnRvuq9pP3f+KiZAZ6Rpz-NKPqW9tnPRX4MmGZ6PK9PT3U_xA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2014 at 04:14:36PM +0200, Henning Rogge wrote:
> I want to force 802.11s only to connect to other stations one layer-2
> hop away. So no forwarding by intermediate stations.
> 
> Does the "mesh_fwding" parameter maybe help? Or can I set a "TTL" for
> the PREQ messages to 1?

Ah, ok got it.  Then yes, you are right, either of those approaches will
disable forwarding.

-- 
Bob Copeland %% www.bobcopeland.com
