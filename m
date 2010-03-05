Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:31611 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab0CEWhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 17:37:53 -0500
Received: by qw-out-2122.google.com with SMTP id 5so632623qwd.37
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 14:37:53 -0800 (PST)
Message-ID: <4B918653.2030808@lwfinger.net>
Date: Fri, 05 Mar 2010 16:31:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Malte Gell <malte.gell@gmx.de>, linux-wireless@vger.kernel.org
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
References: <201003040835.29387.malte.gell@gmx.de> <1267827995.3068.33.camel@mj>
In-Reply-To: <1267827995.3068.33.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2010 04:26 PM, Pavel Roskin wrote:
> I suggest that you check what you have in /lib/firmware.  Looks at the
> file sizes.  Maybe OpenSUSE only loads firmware from directories with
> the kernel version, such as /lib/firmware/2.6.33?

No, openSUSE loads from /lib/firmware.

Larry
