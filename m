Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab1LAL7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 06:59:50 -0500
Date: Thu, 1 Dec 2011 13:00:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Busy looping iwl3945 driver
Message-ID: <20111201120041.GB5706@redhat.com> (sfid-20111201_130007_322640_6DE0420C)
References: <CAJJYPdnaVfkYYT0Y6BseDki4JJcQ=c3UinEYZ+23bX_1xrWDpA@mail.gmail.com>
 <CAJJYPdm3WCyDAVSi2+pa-hQCAMb4k7bCmbdJcREcX4a1CWs4MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJJYPdm3WCyDAVSi2+pa-hQCAMb4k7bCmbdJcREcX4a1CWs4MQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Zdenek

On Thu, Dec 01, 2011 at 12:07:24PM +0100, Zdenek Kabelac wrote:
> Seems to be related to this thread:
> 
> https://lkml.org/lkml/2011/11/29/102

Try to revert f785d83a19bca326f79d127a413e35769afc0105 for
now, proper fix is on the way.

Stanislaw 
