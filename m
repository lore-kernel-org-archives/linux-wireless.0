Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:57697 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968325AbXILSGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 14:06:17 -0400
Received: by nf-out-0910.google.com with SMTP id g13so244188nfb
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2007 11:06:16 -0700 (PDT)
To: Marcus Better <marcus@better.se>
Subject: Re: rt2500 suspend problems
Date: Wed, 12 Sep 2007 20:17:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <fc85aq$uu6$1@sea.gmane.org> <1189594257.6161.45.camel@johannes.berg> <fc8goi$abd$1@sea.gmane.org>
In-Reply-To: <fc8goi$abd$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709122017.47363.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 September 2007, Marcus Better wrote:
> Johannes Berg wrote:
> > No idea, must be a driver bug.
> 
> Anything I can do to debug it?

At least the following:
- compiling rt2x00 with debug enabled,
- providing the debug messages after a suspend/resume
- provide more information about what is exactly is failing during resume.

Ivo
