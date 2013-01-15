Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59927 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab3AOWu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:27 -0500
Received: by mail-wg0-f43.google.com with SMTP id e12so437016wge.34
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2013 14:50:25 -0800 (PST)
Message-ID: <50F5DD2F.2000907@gmail.com> (sfid-20130116_012302_512169_5BD51957)
Date: Tue, 15 Jan 2013 23:50:23 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	=?UTF-8?B?RGFuIEhvcsOhaw==?= <dan@danny.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] linux-firmware: add carl9170 firmware
References: <1342353398-3147-1-git-send-email-xose.vazquez@gmail.com>  <1342666598.11373.97.camel@deadeye.wl.decadent.org.uk> <1358162875.15692.14.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1358162875.15692.14.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2013 12:27 PM, Ben Hutchings wrote:

> OK, I've worked this out now: there are two post-processing steps
> required, one of which is done by './autogen.sh install', and one of
> which (add a checksum) is not done at all.  I've added that step to it
> and can now rebuild a bit-identical image.
> 
> So I've applied this, made a few fixes, and pushed.

Sorry, I took half sabbatical. Now cleaning inbox.

I believe Christian releases a new version(1.9.7) recently,
and I did send 1.9.6 months ago. It should be updated.

Also, Fedora people are working on building the firmware
with native distribution tools, see: http://bugzilla.redhat.com/866051
(Cc: Dan Horák  <dan@danny.cz>)
direct link to the patch: http://bugzilla.redhat.com/attachment.cgi?id=652642

added cc: linux-wireless@vger.kernel.org
