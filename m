Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab3E1LnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 07:43:21 -0400
Message-ID: <1369741393.8548.0.camel@jlt4.sipsolutions.net> (sfid-20130528_134324_610311_6ABDF7DF)
Subject: Re: iwlwifi dmar errors in 3.9.2
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 May 2013 13:43:13 +0200
In-Reply-To: <CAKb7UvhBS6G=1Burf6MfekEnT5vhiy8BKijJ27Fpd=9yBDy9Ng@mail.gmail.com> (sfid-20130520_231244_289559_C8DD3342)
References: <CAKb7UvhBS6G=1Burf6MfekEnT5vhiy8BKijJ27Fpd=9yBDy9Ng@mail.gmail.com>
	 (sfid-20130520_231244_289559_C8DD3342)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-20 at 17:12 -0400, Ilia Mirkin wrote:
> Hello,
> 
> I recently upgraded to 3.9.2 from 3.7.10, and have begun to see some
> DMAR errors in my log. Here are a bunch of them:
> http://pastebin.com/wgq0JW0S

Was there anything in the log _before_ this? Like the device already
getting an error, or so?

johannes

