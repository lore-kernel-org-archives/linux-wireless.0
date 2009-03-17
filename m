Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:4813 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbZCQVSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 17:18:48 -0400
Received: by qw-out-2122.google.com with SMTP id 8so256269qwh.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 14:18:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49BC7117.1010107@gmail.com>
References: <49BC0DBE.90209@gmail.com> <49BC6C21.6020807@gmail.com>
	 <49BC7117.1010107@gmail.com>
Date: Tue, 17 Mar 2009 17:18:45 -0400
Message-ID: <b6c5339f0903171418h6534a5a8w1ef8354f9571657a@mail.gmail.com> (sfid-20090317_221852_101503_13754961)
Subject: Re: ids missing in ath5k ?
From: Bob Copeland <me@bobcopeland.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 14, 2009 at 11:08 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:

> [missing ids: 0x168c: { 0xff1a, 0x0020, 0x101a, 0x9013 } ]

Luis, do you know anything about these devices?  Are all of these
802.11abg or are any .11h (I didn't see ath9k claiming any of
them either).

Should be easy to add support, but would be nice to know if the
hardware exists and will work.

-- 
Bob Copeland %% www.bobcopeland.com
