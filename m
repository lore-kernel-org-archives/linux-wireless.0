Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:37637 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYHELik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 07:38:40 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2551513rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 04:38:40 -0700 (PDT)
Message-ID: <e27b78a40808050438t7b5508e1oe034842427491520@mail.gmail.com> (sfid-20080805_133854_190717_76FFD092)
Date: Tue, 5 Aug 2008 12:38:40 +0100
From: Keir <keirlawson@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Mesh network project, feedback wanted
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm not sure if this is the right place to post this, if it's not then
please let me know.

I am an undergraduate student currently studying software engineering,
and am in the process of work out what my final year
project/dissertation is going to be.  Ideally I would like to do
something on mesh networking as it's a subject that interests me, and
Linux is my operating system of choice.  Though I would consider
myself fairly proficient at C, and I've studied operating systems
though university, I haven't written any real OS code before.  Another
limiting factor is my access to hardware.  I should be able to get my
hands on a couple of linksys routers that can run Linux, and a couple
of laptops, so this will make doing proper testing very difficult.

With this in mind, me and my supervisor came up with the project
proposal that I have attached, however neither of us are hugely
familiar with Linux mesh development.  I was wondering, does this seem
like a sensible project proposal? Is there something better I could be
doing given my resources?

Any feedback on this (even if it's just a "that's a rubbish project,
find something else") is greatly appreciated as I have no ideal of the
merit of the project proposal.

Cheers

Keir Lawson

"Project Proposal

Traditional home wireless networks use a central point, a wireless
access point or router, to both connect to the outside world, the
internet, and to connect devices within the home to each other.  An
alternative scheme for interaction between such devices is to use ad
hoc networks, where devices communicate directly with each other, or
through a path constituted from intermediary devices, avoiding the
need for a central point for routing.  With the traditional solution,
the network has one fail point, if the router goes off-line due to a
fault, the network cannot function, however with the potential
mobility of home computer devices, for example laptops, an ad hoc
solution may also be problematic.

This project will investigate combining these two network types with
in the context of a home environment, and more specifically, will look
at the effect of various different user and application preferences on
route selection.  For example, a user or application could specify
that it prefers to use a traditional managed connection in order to
provide a level of quality of service, or another might specify that
it does not want to cause congestion at the router and so will always
attempt to use an ad hoc path.  Other parameters will also be
investigated, such as reliability of connection required or speed of
connection.

It is envisaged that the Linux implementations of routing protocols
and the IP protocol stack will be suitably orchestrated/modified in
order to react to user preferences over these various parameters, and
that the resulting system will be tested using traditional home
computing hardware, such as a wireless base station, laptops/desktops,
and PDAs."
