Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50248 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbeBSMlr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:41:47 -0500
Message-ID: <1519044105.16723.2.camel@sipsolutions.net> (sfid-20180219_134150_943481_47AA16CE)
Subject: Re: [RFC v4 1/6] uapi: Add 802.11 Preauthentication to if_ether
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 19 Feb 2018 13:41:45 +0100
In-Reply-To: <20180201010420.6102-2-denkenz@gmail.com> (sfid-20180201_020433_861948_847AE78A)
References: <20180201010420.6102-1-denkenz@gmail.com>
         <20180201010420.6102-2-denkenz@gmail.com>
         (sfid-20180201_020433_861948_847AE78A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-31 at 19:04 -0600, Denis Kenzior wrote:
> This adds 0x88c7 protocol type to if_ether.

I'll just apply this now.

johannes
