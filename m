Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:27396 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZBIS5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 13:57:07 -0500
Received: by fg-out-1718.google.com with SMTP id 16so1115654fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 10:57:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c910902091056h119b3fa4g460e5e18288c1c3c@mail.gmail.com>
References: <69e28c910902091056h119b3fa4g460e5e18288c1c3c@mail.gmail.com>
Date: Mon, 9 Feb 2009 19:57:03 +0100
Message-ID: <69e28c910902091057y248abef4wf78bc40cc2c37fcd@mail.gmail.com> (sfid-20090209_195711_588972_FBF244B1)
Subject: Re: Proposal: Add a new flag to the proposed TX flags field to
	control the sequence number of injected packets
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: radiotap@radiotap.org, Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 9, 2009 at 7:56 PM, G=E1bor Stefanik <netrolller.3d@gmail.c=
om> wrote:
> them. So, userspace can in these cases set TX_FLAGS |=3D3D 0x0010 and=
 put
Sorry for the typo - this was meant to be "TX_FLAGS |=3D 0x0010".

G=E1bor
--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
