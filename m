Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:43655 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYBTSng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:43:36 -0500
Received: by el-out-1112.google.com with SMTP id v27so1316094ele.23
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2008 10:43:34 -0800 (PST)
Message-ID: <1ba2fa240802201043v1bd4fbddsc55c2230eb2a1480@mail.gmail.com> (sfid-20080220_184340_350404_30012B97)
Date: Wed, 20 Feb 2008 20:43:33 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: implementing APSD?
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Michael Renzmann" <mrenzmann@madwifi.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"bruno randolf" <br1@einfach.org>
In-Reply-To: <1203521087.17534.74.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1203521087.17534.74.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 20, 2008 5:24 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
> I've long thought about implementing APSD but it seems to require
> setting the "more data" bit in an ACK frame and various other things.
> Ron, I think you're the QoS expert, is that really how APSD works? If
> so, does iwl firmware implement that?

We have uAPSD implementation, mainly AP part, yet again it for  older
mac. It will take a bit time to merge it in
It's a mandatory feature for HT AP.

> Also, does Atheros hardware implement that, and how? It doesn't look
> like Broadcom firmware implements it, and I don't really understand how
> one could implement it without many hardware queues, since it seems
> timing critical to send out the frames to the station that is using
> APSD.
>
Don't believe it's possible to that without HW support.

Tomas
> Any clues?
>
> johannes
>
