Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33400 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbGGGkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 02:40:10 -0400
MIME-Version: 1.0
In-Reply-To: <559B6FF8.9010704@users.sourceforge.net>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<558EB32E.6090003@users.sourceforge.net>
	<558EB4DE.3080406@users.sourceforge.net>
	<20150707023103.GA22043@kroah.com>
	<559B6FF8.9010704@users.sourceforge.net>
Date: Tue, 7 Jul 2015 08:40:08 +0200
Message-ID: <CAH6sp9Nn7LKdqT9E0bykY8jpEc-Ugxn8wby5yLcW+nsx=yG3NQ@mail.gmail.com> (sfid-20150707_084031_015687_D93F8BF7)
Subject: Re: Clarification for the use of additional fields in the message body
From: Frans Klaver <fransklaver@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris Park <chris.park@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Julia Lawall <julia.lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 7, 2015 at 8:21 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>>> From: Markus Elfring <elfring@users.sourceforge.net>
>>> Date: Sat, 27 Jun 2015 15:56:57 +0200
>>
>> Why is this in the body of the email?
>
> Does the canonical patch format support to preserve
> specific details about a shown commit by specification
> of fields like "Date" and "From" in the message body?

Using "From:" in the body can be used to provide your properly spelled
name, or the name/e-mail of the actual author, if that happens not to
be the sender. git-send-email will do that automagically for you. If
"From:" is not specified in the message body, the e-mails sender will
be used as author.

The date, as far as I know, is ignored. It is the commit date, not the
authoring date, and once your patch is applied by a maintainer (i.e.
committed), the date gets reset anyway. No need to try and preserve
it.

Frans
