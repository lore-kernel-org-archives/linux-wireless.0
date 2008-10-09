Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:55494 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbYJIRrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 13:47:18 -0400
Received: by fg-out-1718.google.com with SMTP id 19so83640fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2008 10:47:16 -0700 (PDT)
Message-ID: <45e8e6c40810091047t524b1531mc273393f2a2ad33a@mail.gmail.com> (sfid-20081009_194723_447477_36233DBF)
Date: Thu, 9 Oct 2008 10:47:16 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] allow AP interfaces to handle BACK action frames
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45e8e6c40810091038i697c9615pb7121882a54d5873@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48ed3fd6.1e068e0a.7847.4d37@mx.google.com>
	 <1223546217.22490.31.camel@johannes.berg>
	 <45e8e6c40810091038i697c9615pb7121882a54d5873@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

oops, I meant "don't call a handler for the frame", not "don't pass
the frame to the driver", sorry.
