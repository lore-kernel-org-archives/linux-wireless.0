Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4859 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaFIMGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 08:06:00 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: wil6210: improve debug for WMI receive
Date: Mon, 9 Jun 2014 15:05:47 +0300
Message-ID: <1431413.xV8ODJtznW@lx-wigig-72> (sfid-20140609_140605_048535_36B76DDE)
In-Reply-To: <20140609093518.GA10589@mwanda>
References: <20140609093518.GA10589@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 09, 2014 12:35:18 PM Dan Carpenter wrote:
>    746          if (n > 1)
>                 ^^^^^^^^^^
> We never reach this if statemtent.

Dan,

Thanks for this. I'll upload fix shortly.
Caused by the missed chunk in rebase.

Thanks, Vladimir
