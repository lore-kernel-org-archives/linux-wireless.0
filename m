Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:11225 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYBXMDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 07:03:17 -0500
Received: by rv-out-0910.google.com with SMTP id k20so718261rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2008 04:03:15 -0800 (PST)
Message-ID: <84ac67910802240403l3de7dd0fib949a0b3a78f1776@mail.gmail.com> (sfid-20080224_120340_898914_E6E40822)
Date: Sun, 24 Feb 2008 12:03:15 +0000
From: "Ahmed Ammar" <b33fc0d3@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: b43 (H/W 4306 Rev. 03)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <84ac67910802231156t29724612me8adb74d05bfede8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com>
	 <84ac67910802230523u14646c4dg97f9ce40c21b9c26@mail.gmail.com>
	 <1203773250.13162.23.camel@johannes.berg>
	 <84ac67910802230559g73dafb0focbf62f4b9a6b3158@mail.gmail.com>
	 <1203776102.13162.27.camel@johannes.berg>
	 <84ac67910802230628q217542e4gc76bed8076af118f@mail.gmail.com>
	 <1203777414.13162.29.camel@johannes.berg>
	 <84ac67910802230925xb7750e8j561efaf951c50321@mail.gmail.com>
	 <1203794030.13162.39.camel@johannes.berg>
	 <84ac67910802231156t29724612me8adb74d05bfede8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also,
I've found out that this seems to be a pci only issue, other users
with the exact same PHY revision on cardbus report b43 working fine.
