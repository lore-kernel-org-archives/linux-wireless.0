Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:49180 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbYLBRTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 12:19:48 -0500
Received: by qyk4 with SMTP id 4so3545479qyk.13
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 09:19:46 -0800 (PST)
Message-ID: <e27b78a40812020919l2d5acedbld4e853159a6a7a01@mail.gmail.com> (sfid-20081202_182005_344120_6A5EF137)
Date: Tue, 2 Dec 2008 17:19:46 +0000
From: Keir <keirlawson@gmail.com>
To: linux-wireless@vger.kernel.org,
	"Andrey Yurovsky" <andrey@cozybit.com>
Subject: Fwd: Problems with o11s
In-Reply-To: <e27b78a40812020752o396b2542kfc26b55caeade8df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812020752o396b2542kfc26b55caeade8df@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've had o11s working for a while now, but I seem to get a strange
problem whereby pinging between MPs works for the first few pings, and
then I start getting packet loss (Destination Host Unreachable)  and
nothing gets through, despite the other station being listed as
"ESTAB" by iw.  I'm not sure if there is something strange about my
setup, or this is a bug somewhere, anyone got any ideas? I'm using
revision d059b2aed9e93cb94364e01374bca90ce3dc0ef9

Cheers

Keir
