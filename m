Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2EaJKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 05:10:03 -0400
Message-ID: <1338455399.7328.0.camel@jlt3.sipsolutions.net> (sfid-20120531_111040_962193_C2F998A4)
Subject: Re: Master mode support in iwlagn?
From: Johannes Berg <johannes@sipsolutions.net>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Date: Thu, 31 May 2012 11:09:59 +0200
In-Reply-To: <3093264.LxkCudZSCQ@sylvesterjr.cmi.ua.ac.be> (sfid-20120531_110420_574883_2E884A12)
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be>
	 <1338417129.8887.32.camel@dcbw.foobar.com>
	 <1338450022.4531.3.camel@jlt3.sipsolutions.net>
	 <3093264.LxkCudZSCQ@sylvesterjr.cmi.ua.ac.be>
	 (sfid-20120531_110420_574883_2E884A12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please don't top-post.

On Thu, 2012-05-31 at 11:03 +0200, Erwin Van de Velde wrote:
> What is the reasoning behind it? Why provide it for some wireless NICs and not 
> for others? Seems quite odd for me and features like Internet sharing over 
> wireless are not that exotic, are they?

This features requires extensive testing, space in the firmware that not
all devices have, integration, etc. It's not trivial to port to
different devices.

johannes

