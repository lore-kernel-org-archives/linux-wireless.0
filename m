Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34350 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbeCUHNs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 03:13:48 -0400
Date: Wed, 21 Mar 2018 10:13:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 04/11] staging: wilc1000: refactor WILC_WFI_p2p_rx() to
 avoid line over 80 char
Message-ID: <20180321071333.v5yr6qe7ygituyst@mwanda> (sfid-20180321_081355_559207_3928D1D5)
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
 <1521564944-3565-5-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521564944-3565-5-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This one would have been easier for me to review if it were broken up
slightly differently.  I have a script to review when people split
functions up, but there were a bunch of other stuff so my script gets
confused.

Anyway, looks good.

regards,
dan carpenter
